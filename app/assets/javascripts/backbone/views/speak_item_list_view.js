var SpeakItemListView = Backbone.View.extend({

    tagName: 'ul',

    // Renders view
    render: function() {

        var element =  this.$el; // Must be defined outside loop - or else Bad Things Happens (tm)

        _.each(this.collection.models, function(model, index, list) {
            var view = new SpeakItemView({model: model});
            element.append(view.render().el)
        });
        return this;
    }
});