{
  function makeInt(o) {
    return parseInt(o.join(""), 10);
  }

  function makeFloat(o) {
    return parseFloat(o.join(""), 10);
  }

  function makeString(o) {
    return o.reduce(function(acc, el) {
        if(el === "\\") {
            if(acc.special) {
                return {content: acc.content + "\\", special: false};
            }
            return {content: acc.content, special: true};
        }
        return acc + el;
    }, { content: "", special: false });
  }

  function token(type, content) {
    return {type: type, content: content};
  }

  function makeIdentifier(o) {
    return o.join("");
  }
}

start
  = space* content:topLevelExpr* space* {return {type: "start", content: content};}
  / space* {return {type: "start", content: null};}

comment
  = "//" [^\n]* [\n]+

space 
  = " " space*
  / [\r\n]+ space*
  / comment space*

topLevelExpr
  = space* valDef:valDef space* {return {type: "topLevelExpr", content: valDef};}
  / space* typeDef:typeDef space* {return {type: "topLevelExpr", content: typeDef};}

valDef
  = space* id:identifier space* "=" expr:expr space* {return {type: "valDef", id: id, expr: expr};}

typeDef
  = space* id:identifier space* ":" expr:expr space* {return {type: "typeDef", id: id, expr: expr};}

expr
  = space* expr:identifier space* {return {type: "expr", content: expr};}
  / space* expr:literal1 space* {return {type: "expr", content: expr};}
  / space* expr:primary space* {return {type: "expr", content: expr};}
  / call expr:call space* {return {type: "expr", content: expr};}

call
  = space* id:identifier space* "(" exprs:expr* ")" space* {return {type: "call", id: id, exprs: exprs};}

primary
  = space* "(" exprs:expr* ")" space* {return {type: "primary", exprs: exprs};}

identifier
  = space* syms:[a-zA-Z_]+[a-zA-Z_0-9]* space* { return {type: "identifier", content:makeIdentifier(syms)}; }

literal1
  = content:number { return {type: "literal", content: content}; }
  / content:string { return {type: "literal", content: content}; }

number
  = space* digits:[0-9]+ space* { return {type: "number", content: makeInt(digits)}; }
  / space* digits:[0-9]+[\.][0-9]* space* { return {type: "number", content: makeFloat(digits)}; }
  / space* digits:[0-9]*[\.][0-9]+ space* { return {type: "number", content: makeFloat(digits)}; }

string
  = space* '"' chars:[^(")(\\")]* '"' space* { return {type: "string", content: makeString(chars)}; }