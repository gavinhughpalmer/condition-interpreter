/**
 * Created by admin-1019 on 13/06/2018.
 */
@isTest
private class LexerTest {

    @isTest
    private static void getNextTokenTestSingleKeyword() {
        final String textToRead = 'aToken';
        Lexer lexer = new Lexer(textToRead);

        Token returnedToken = lexer.getNextToken();

        System.assertEquals(
            Token.Type.KEYWORD, returnedToken.type,
            'The returned token type should be a keyword'
        );

        System.assertEquals(
            textToRead, (String) returnedToken.value,
            'The token returned should be the text: ' + textToRead
        );
    }

    @isTest
    private static void getNextTokenTestIndexToken() {
        final Integer indexValue = 10;
        Lexer lexer = new Lexer(String.valueOf(indexValue));

        Token returnedToken = lexer.getNextToken();

        System.assertEquals(
            Token.Type.INDEX, returnedToken.type,
            'The returned token type should be a keyword'
        );

        System.assertEquals(
            indexValue, (Integer) returnedToken.value,
            'The token returned should be the index: ' + indexValue
        );
    }

    @isTest
    private static void getNextTokenTestLeftBracket() {
        Lexer thisLexer = new Lexer(Lexer.LEFT_BRACKET);

        Token returnedToken = thisLexer.getNextToken();

        System.assertEquals(
            Token.Type.LEFT_BRACKET, returnedToken.type,
            'The returned token type should be a keyword'
        );

        System.assertEquals(
            Lexer.LEFT_BRACKET, (String) returnedToken.value,
            'The token returned should be the left bracket'
        );
    }

    @isTest
    private static void getNextTokenTestRightBracket() {
        Lexer thisLexer = new Lexer(Lexer.RIGHT_BRACKET);

        Token returnedToken = thisLexer.getNextToken();

        System.assertEquals(
            Token.Type.RIGHT_BRACKET, returnedToken.type,
            'The returned token type should be a keyword'
        );

        System.assertEquals(
            Lexer.RIGHT_BRACKET, (String) returnedToken.value,
            'The token returned should be the right bracket'
        );
    }

    @isTest
    private static void getNextTokenTestSkipWhitespace() {
        Lexer lexer = new Lexer('    ');
        Token endOfFile = lexer.getNextToken();

        System.assertEquals(
            Token.Type.EOF, endOfFile.type,
            'The whitespace should be skipped until the end of the file is reached'
        );
    }

    @isTest
    private static void getNextTokenTestInvalidCharacter() {
        String invalidCharacter = '*';
        Lexer lexer = new Lexer(invalidCharacter);
        try {
            lexer.getNextToken();
            System.assert(false, 'An exception should have been thrown');
        } catch (Lexer.InvalidTokenException exceptionToHandle) {
            System.assert(
                exceptionToHandle.getMessage().contains(invalidCharacter),
                'The error message should contain the invalid character'
            );
        } catch (Exception exceptionToHandle) {
            System.assert(false, 'A more specific error should be thrown ' + exceptionToHandle.getMessage());
        }
    }
}