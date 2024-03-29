import { ts } from "../../deps.ts";

export type Metadata = {
  functionName: string;
  doc?: string;
  moduleDescription?: string;
  parameters: {
    name: string;
    type: string;
    optional: boolean;
    doc: string;
    defaultValue?: string;
  }[];
  returnType: string;
};

export default function introspect(source: string) {
  const program = ts.createProgram([source], { experimentalDecorators: true });
  const files = program
    .getSourceFiles()
    .filter((file) => !file.isDeclarationFile);

  if (!files.length) {
    throw new Error("No source file found");
  }

  const checker = program.getTypeChecker();
  const metadata: Metadata[] = [];
  let moduleDescription: string | undefined = undefined;

  for (const file of files) {
    ts.forEachChild(file, (node) => {
      if (
        ts.getJSDocTags(node).find((tag) => tag.tagName.getText() === "module")
      ) {
        moduleDescription = ts
          .getJSDocTags(node)
          .find((tag) => tag.tagName.getText() === "description")
          ?.comment as string;
      }

      if (ts.isFunctionDeclaration(node)) {
        const signature = checker.getSignatureFromDeclaration(node);
        const returnType = checker.getReturnTypeOfSignature(signature!);
        const parameters = signature!.getParameters().map((parameter) => {
          const doc = ts.displayPartsToString(
            parameter.getDocumentationComment(checker)
          );
          const parameterType = checker.getTypeOfSymbolAtLocation(
            parameter,
            parameter.valueDeclaration!
          );
          const parameterName = parameter.getName();
          const parameterTypeString = checker.typeToString(parameterType);
          const optional = isOptional(parameter);
          return { parameterName, parameterTypeString, doc, ...optional };
        });
        const functionName = node.name!.getText();
        const docTags = ts.getJSDocTags(node);
        const returnTypeString = checker.typeToString(returnType);

        if (
          docTags.filter((tag) => tag.tagName.getText() === "function")
            .length === 0
        ) {
          return;
        }

        metadata.push({
          functionName,
          moduleDescription,
          doc: docTags
            .map((tag) => tag.comment)
            .find((comment) => comment) as string,
          parameters: parameters.map(
            ({
              parameterName,
              parameterTypeString,
              optional,
              defaultValue,
              doc,
            }) => ({
              name: parameterName,
              type: parameterTypeString,
              doc,
              optional,
              defaultValue,
            })
          ),
          returnType: returnTypeString,
        });
      }
    });
  }
  return metadata;
}

function isOptional(param: ts.Symbol): {
  optional: boolean;
  defaultValue?: string;
} {
  const declarations = param.getDeclarations();

  // Only check if the parameters actually have declarations
  if (declarations && declarations.length > 0) {
    const parameterDeclaration = declarations[0];

    // Convert the symbol declaration into Parameter
    if (ts.isParameter(parameterDeclaration)) {
      const optional =
        parameterDeclaration.questionToken !== undefined ||
        parameterDeclaration.initializer !== undefined;

      if (parameterDeclaration.initializer) {
        const defaultValue = formatDefaultValue(
          parameterDeclaration.initializer.getText()
        );
        return {
          optional,
          defaultValue,
        };
      }

      return {
        optional:
          parameterDeclaration.questionToken !== undefined ||
          parameterDeclaration.initializer !== undefined,
      };
    }
  }

  return { optional: false };
}

function formatDefaultValue(value: string): string {
  const isSingleQuoteString = (): boolean =>
    value.startsWith("'") && value.endsWith("'");

  if (isSingleQuoteString()) {
    return `"${value.slice(1, value.length - 1)}"`;
  }

  return value;
}
