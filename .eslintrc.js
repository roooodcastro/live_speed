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
    'no-var': 'error',
    'switch-colon-spacing': 'error',
    'object-curly-spacing': ['error', 'always'],
    'no-tabs': 'error',
    'comma-spacing': 'error',
    'keyword-spacing': 'error',
    'brace-style': 'error',
    'eol-last': 'error',
    'no-undefined': 'error',
    'no-with': 'error',
    'no-useless-return': 'error',
    'no-eq-null': 'error',
    'eqeqeq': 'error',
    'complexity': 'error',
    //'class-methods-use-this': 'error',
    'no-useless-concat': 'error',
    'block-scoped-var': 'error',
    'no-lonely-if': 'error',
    'no-whitespace-before-property': 'error',
    'space-before-blocks': 'error',
    'no-console': 'warn',
    'space-before-function-paren': ['error', {
      anonymous: 'always',
      named: 'never',
      asyncArrow: 'always'
    }],
    'space-in-parens': ['error', 'never'],
    'space-infix-ops': 'error',
    'spaced-comment': ['error', 'always', {
      exceptions: ['-', '+']
    }],
    'no-multi-spaces': ['error', {
      exceptions: {
        'VariableDeclarator': true,
        'Property': true,
        'ImportDeclaration': true,
        'AssignmentExpression': true
      }
    }],
    'max-len': ['error', {
      code: 120
    }],
    'quotes': ["error", "single", {
      "allowTemplateLiterals": true
    }]
  },
  env: {
    browser: true,
    node: true,
    jquery: false,
    es6: true
  }
};
