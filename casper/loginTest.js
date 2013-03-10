// Test logging in

casper.test.comment('Test logging in');

casper.start('http://localhost:3000/', function() {
    this.clickLabel('Login', 'a');
    this.then(function() {
        this.test.assertExists('form', 'login form exists');
        this.test.assertUrlMatch('http://localhost:3000/auth/login');

        this.fill('form', {
            'username' : 'testuserone',
            'password' : 'password'
        }, true);
        this.then(function() {

            this.test.assertExists('div .alert', 'alert exists');
            this.test.assertSelectorHasText('div .alert', 'Logged in');
            
            this.test.assertSelectorHasText('a', 'Logout');
            this.test.assertSelectorDoesntHaveText('a', 'Login');

        });
    });

});

casper.run(function() {
    this.test.done(6);
});
