<% if (image) { %>![You're Awesome](http://24.media.tumblr.com/tumblr_mc17h9yIdO1rj9qh8o1_1280.jpg)<% } %>
<% if (!check && sender) { %>Hey @<%= sender %>,
thank you for your Pull Request.<% } %>

<% if (maintainer){ print('@'+maintainer)} %> It looks like <% if (check) { print('@'+sender+' just') } else {print('this brave person')} %> signed our Contributor License Agreement. :+1:

Always at your service,

clabot
