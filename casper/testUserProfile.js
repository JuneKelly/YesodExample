// Test the User Profile page

casper.test.comment('Test User Profile page');

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

            this.test.assertSelectorHasText('a', 'My Profile');
            
            this.clickLabel('My Profile', 'a');
            this.then(function() {                
                this.test.assertSelectorHasText('h1', 'Testuser One');
                this.test.assertSelectorHasText('p', 'Username: testuserone');
                this.test.assertSelectorHasText('a', 'Edit Profile');
            });
        });
    });
});

casper.run(function() {
    this.clickLabel('Logout', 'a');
    this.test.done(6);
});
