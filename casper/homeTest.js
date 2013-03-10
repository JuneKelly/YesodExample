// Test the homepage

casper.test.comment('Test the homepage');

casper.test.assert(true, "true is so true");
casper.test.assertNot(false, "false is wrong");

casper.start('http://localhost:3000/', function() {
    this.test.assertExists('.navbar', 'navbar exists');

    this.test.assertSelectorHasText('h1', 'Welcome');
    this.test.assertSelectorHasText('p', 'This is an example of Yesod in action');
});

casper.run(function() {
    this.test.done(5); // I must be called once all the async stuff
                       // has been executed. I'll also check that a
                       // single assertions has been performed.
});
