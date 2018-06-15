/**
 * Created by admin-1019 on 08/06/2018.
 */

public class ConditionInterpreter {

    public class InvalidLogicException extends Exception {
    }

    private final Map<Integer, Condition> conditionsByIndex;
    private final String conditionalLogic;
    private Lexer lexer;
    private Token currentToken;

    public ConditionInterpreter(String conditionalLogic, Map<Integer, Condition> conditionsByIndex) {
        this.conditionsByIndex = conditionsByIndex;
        this.conditionalLogic = conditionalLogic;
    }

    public Boolean isMatch(SObject recordToCheck) {
        lexer = new Lexer(conditionalLogic);
        currentToken = lexer.getNextToken();
        return interpretLogic(recordToCheck);
    }

    private Boolean evaluateCondition(Integer index, SObject recordToCheck) {
        if (!conditionsByIndex.containsKey(index)) {
            throw new InvalidLogicException('The index ' + index + ' cannot be found in the conditions provided');
        }
        return conditionsByIndex.get(index).isMatch(recordToCheck);
    }

    private void eat(Token.Type expectedTokenType) {
        if (currentToken.type == expectedTokenType) {
            currentToken = lexer.getNextToken();
        } else {
            throw new InvalidLogicException('Invalid syntax, expected ' + expectedTokenType.name() + ' received ' + currentToken.toString());
        }
    }

    private Boolean evaluateConditionIndex(SObject recordToCheck) {
        Boolean result = false;
        Token tempToken = currentToken;
        if (tempToken.type == Token.Type.INDEX) {
            eat(Token.Type.INDEX);
            result = evaluateCondition((Integer) tempToken.value, recordToCheck);
        } else if (tempToken.type == Token.Type.LEFT_BRACKET) {
            eat(Token.Type.LEFT_BRACKET);
            result = interpretLogic(recordToCheck);
            eat(Token.Type.RIGHT_BRACKET);
        } else {
            throw new InvalidLogicException('Invalid syntax unexpected ' + currentToken.toString());
        }
        return result;
    }

    private Boolean interpretLogic(SObject recordToCheck) {
        Boolean result = evaluateConditionIndex(recordToCheck);
        while (currentToken.type == Token.Type.KEYWORD) {
            String operator = ((String) currentToken.value).toLowerCase();
            if (operator == 'and') {
                eat(Token.Type.KEYWORD);
                result = evaluateConditionIndex(recordToCheck) && result;
            } else if (operator == 'or') {
                eat(Token.Type.KEYWORD);
                result = evaluateConditionIndex(recordToCheck) || result;
            } else {
                throw new InvalidLogicException('Invalid syntax, unexpected ' + currentToken.toString());
            }
        }
        return result;
    }
}