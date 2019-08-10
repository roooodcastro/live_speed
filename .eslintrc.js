module.exports = {
  parserOptions: {
    ecmaVersion: 2018
  },
  extends: [
    'eslint:recommended',
    'plugin:vue/essential',
    'plugin:vue/strongly-recommended',
    'plugin:vue/recommended'
  ],

  globals: {
    App: true
  },
  rules: {
    'block-scoped-var': 'error',
    'brace-style': 'error',
    'comma-dangle': ['error', 'always'],
    'comma-spacing': 'error',
    'complexity': 'error',
    'eol-last': 'error',
    'eqeqeq': 'error',
    'init-declarations': ['error', 'always'],
    'keyword-spacing': 'error',
    'max-len': ['error', {
      code: 120
    }],
    'no-console': 'warn',
    'no-eq-null': 'error',
    'no-lonely-if': 'error',
    'no-multi-spaces': ['error', {
      exceptions: {
        'VariableDeclarator': true,
        'Property': true,
        'ImportDeclaration': true,
        'AssignmentExpression': true
      }
    }],
    'no-return-assign': ['error', 'always'],
    'no-tabs': 'error',
    'no-var': 'error',
    'no-undefined': 'error',
    'no-useless-concat': 'error',
    'no-useless-return': 'error',
    'no-with': 'error',
    'no-whitespace-before-property': 'error',
    'object-curly-spacing': ['error', 'always'],
    'quotes': ["error", "single", {
      "allowTemplateLiterals": true
    }],
    'space-before-blocks': 'error',
    'space-before-function-paren': ['error', {
      anonymous: 'always',
      named: 'never',
      asyncArrow: 'always'
    }],
    'space-in-parens': ['error', 'never'],
    'space-infix-ops': 'error',
    'spaced-comment': ['error', 'always', { exceptions: ['-', '+'] }],
    'switch-colon-spacing': 'error',
    'yoda': 'error'
  },
  env: {
    browser: true,
    node: true,
    jquery: false,
    es6: true
  }
};
