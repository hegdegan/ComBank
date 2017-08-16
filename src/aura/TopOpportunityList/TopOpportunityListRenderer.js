({
    afterRender: function(component, helper) {
        this.superAfterRender();
        console.log('renderer');
    }
})