// Test logging in

casper.test.comment('Test logging in');

casper.start('http://localhost:3000/', function() {
    this.clickLabel('Login', 'a');
    this.then(function() {
        this.test.assertExists('form', 'login form exists');
        this.test.assertUrlMatch('http://localhost:3000/auth/login');
    });

});

casper.run(function() {
    this.test.done(2);
});
