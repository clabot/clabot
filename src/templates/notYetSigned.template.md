<% if (image) { %>![Soon you'll be Awesome](http://25.media.tumblr.com/tumblr_m861ia4kaB1qjwvg9o1_500.gif)<% } %>
<% if (!check && sender) { %>Hey @<%= sender %>,
thank you for your Pull Request.<% } %>

It looks like <% if (check) { print('@'+sender+' hasn\'t') } else { print('you haven\'t') } %> signed our **C**ontributor **L**icense **A**greement, yet.

<% if (!check) { %>> The purpose of a CLA is to ensure that the guardian of a project's outputs has the necessary ownership or grants of rights over all contributions to allow them to distribute under the chosen licence.
[Wikipedia](http://en.wikipedia.org/wiki/Contributor_License_Agreement)

<% if (link) { %>You can read and sign our full Contributor License Agreement [here](<%= link %>).<% } %>

Once you've signed reply with `[clabot:check]` to prove it.<% }%>

Appreciation of efforts,

clabot
