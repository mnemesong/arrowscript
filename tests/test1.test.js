const fs = require("fs")
const path = require("path")
const parser = require("../parser-peg/parser")
const assert = require("assert")
const mocha = require("mocha")

const srcPath = path.resolve(module.path, "..", "examples", "example1.ars")
const srcCode = fs.readFileSync(srcPath).toString()

mocha.it("test example1", () => {
    const result = parser.parse(srcCode);
    const nominal = {
        type: "start",
        content: [
            {
                type: "topLevelExpr",
                content: {
                    type: "valDef",
                    id: {
                        type: "identifier",
                        content: "a"
                    },
                    expr: {
                        type: "expr",
                        content: {
                            type: "literal",
                            content: {
                                type: "number",
                                content: 12
                            }
                        }
                    }
                }
            },
            {
                type: "topLevelExpr",
                content: {
                    type: "typeDef",
                    id: {
                        type: "identifier",
                        content: "b"
                    },
                    expr: {
                        type: "expr",
                        content: {
                            type: "identifier",
                            content: "Int"
                        }
                    }
                }
            }
        ],
    }
    assert.deepEqual(result, nominal);
})

