# clabot [![Build Status](https://travis-ci.org/clabot/clabot.png?branch=master)](https://travis-ci.org/clabot/clabot)

[![Greenkeeper badge](https://badges.greenkeeper.io/clabot/clabot.svg)](https://greenkeeper.io/)

![clabot](http://en.gravatar.com/userimage/20257526/bb65aa5c4ec93b91c4a2c620d2181d3d.png?size=256)

clabot **automatically checks Pull Requests** submitted to your repository.

If the sender hasn't signed the **C**ontributor **L**icense **A**greement, it **comments with instructions**, otherwise the maintainer will be notified.

*[What a CLA is and why you need one](http://en.wikipedia.org/wiki/Contributor_License_Agreement)*

![post fancy gifs like it's 1995](http://i.imgur.com/x9ovPJ7.gif)

**The bot is fully customizeable:**
* Hook any API into the `getContractors` mechanism.
* Provide templates to adapt clabot's comments to your needs
* Flags to ignore pull requests from collaborators or people who have already contributed

You can even trigger clabot manually with a **special comment API**. Reply with `[clabot:check]` to any pull request and you'll instantly see wether the sender has signed or not.

This dramatically **reduces the time investement** needed to establish a strict contribution policy for your projects.

**The focus of this project lies on communication automation:**
* No more painful begging for replies
* No more hours of processing the pull request queue
* No more manually checking the contractor database

The bot is written in coffeescript, running on node.js. Due to [pubsubhubhub](http://developer.github.com/v3/repos/hooks/#pubsubhubbub) and GitHub's live updates answers will appear almost instantly.

## Try it out

Feel free to open pull requests in our [sandbox](http://github.com/clabot/sandbox) environment.
Experience how clabot automatically responds, guiding you through the process of signing a Contributors License Agreement.
*Note:* If you don't want to go through the hassle of forking the repo just reply `[clabot:check]` to any of the pull requests.
You can use `[clabot:check=yourusername]` to check your own status.

## Getting Your Own

**You'll probably never have to hack on this repo directly.**

Instead this repo provides a library that's distributed by npm that you simply require in your project.

We have set up a [sample implementation](http://github.com/clabot/sample). Look at the code there or fork our [boilerplate](http://github.com/clabot/boilerplate) and follow the [tutorial](https://github.com/clabot/boilerplate/blob/master/README.md).

## Documentation

clabot is available on the npm registry.
```bash
npm install clabot
```

You require clabot and call `clabot.createApp(options)`. This will return a new [express.js](http://expressjs.com) app.
Based on the options provided this already sets up some clabot specific routes and middlewares.

All you have to do is listen to a port and clabot will be up and running.

```js
app = require('clabot').createApp(options);
app.listen(process.env.PORT || 1337);
```

If your app requires middleware to be added before clabot's middleware, you can pass in an Express app for clabot to use instead of creating a new one.

```js
options.app = express();
// add some middleware here
app = require('clabot').createApp(options);
app.listen(process.env.PORT || 1337);
```

In order to receive events from GitHub you have to subscribe.
clabot will never push code to the repositories, but push access is required to be able to receive events from the GitHub API.

```bash
curl -u "clabotusername" -i https://api.github.com/hub -F "hub.mode=subscribe" -F "hub.topic=https://github.com/:user/:repo/events/pull_request" -F "hub.callback=http://your-clabot.herokuapp.com/notify" -F "hub.secret=supersecretrandomstring"

curl -u "clabotusername" -i https://api.github.com/hub -F "hub.mode=subscribe" -F "hub.topic=https://github.com/:user/:repo/events/issue_comment" -F "hub.callback=http://your-clabot.herokuapp.com/notify" -F "hub.secret=supersecretrandomstring"
```

*Note:* You have to do both of the commands for every repository that should be observed. One command for pull requests and one for comments on those.

[http://developer.github.com/v3/repos/hooks/#pubsubhubbub](http://developer.github.com/v3/repos/hooks/#pubsubhubbub)


### Options

#### getContractors(callback)

Type: `Function`

*required*

This function will be called by clabot in case it needs a list of all signed contractors.
Provide a function here that queries your database and calls the callback with an array of GitHub usernames.

#### addContractor(contractor, callback)

Type: `Function`

*optional*

This function will be called by clabot in case it needs to add a contractor to the list of signed contractors.
Provide a function here that adds a contractor to your database and calls the callback with a boolean success flag.

#### token

Type: `String`

*required*

A valid GitHub oAuth token with access to all repositories that clabot should observe.

*Note:* It's highly recommended that you **don't commit the token to your repository**. Use environment variables.

*Note:* It's highly recommended that you **create a sperate GitHub account for your clabot**.

```bash
curl -u 'clabotusername' -d '{"scopes":["repo"],"note":"clabot"}' https://api.github.com/authorizations
```
[Creating an OAuth token for command-line use](https://help.github.com/articles/creating-an-oauth-token-for-command-line-use)


#### templates

Type: `Object`

*optional*

clabot provides pretty cool standard templates, but if they don't fit your needs you can specify custom ones.
The object may specify: `alreadySigned` and `notYetSigned`. You should have a look at the [originals](src/templates).
*Note:* Templates are processed by [lodash's](http://lodash.com) `_.template`

#### templateData

Type: `Object`

Specify details displayed in clabot's answers. You may specify any data you like, so you can access it in your custom templates
.
* "image": 'Boolean' show funny gifs in the response
* "link": 'String' link to your electronical submission form
* "maintainer": 'String' GitHub username to be notified, if CLA was signed

#### secrets

Type: `Object`

*required*

The secrets you provided when subscribing to GitHub's events. Organized in a user/repo way so you can vary secrets on a per repo basis.

```js
secrets: {
  username:
    reponame: 'secret1'
    reponame2: 'secret2'
}
```
*Note:* It's highly recommended that you **don't commit secrets to your repository**. Use environment variables.

#### skipCollaborators

Type: `Boolean`

Default: false

Don't answer to pull request from people with push access to the repository.

#### skipContributors

Type: `Boolean`

Default: true

Don't answer to pull request from people who have already contributed to the repository.

## Misc & Attributions

**Don't know what the whole CLA thing is about?**

> The purpose of a CLA is to ensure that the guardian of a project's outputs has the necessary ownership or grants of rights over all contributions to allow them to distribute under the chosen licence.
[Wikipedia](http://en.wikipedia.org/wiki/Contributor_License_Agreement)

**Need a Contributor License Agreement template?**

> Project Harmony is a community-centered group focused on contributor agreements for free and open source software (FOSS) [Project Harmony](http://www.harmonyagreements.org/index.html)

**Wanna hang out and chat about clabot?**

[Join our HipChat room](https://www.hipchat.com/gBZFBJa2w)

**clabot is [MIT licensed](LICENSE). In case you forgot about the most important part of it:**

> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> OTHER DEALINGS IN THE SOFTWARE.

We aren't lawyers, and none of the clabot documentation, functionality, or other communication constitutes legal advice. Consult your lawyer about a Contributor License Agreement.

<hr />

authored by **[Stephan Bönnemann](https://github.com/boennemann) - [@boennemann](https://twitter.com/boennemann)**

maintained by [excellenteasy](https://github.com/excellenteasy)

clabot logo by [Proycontec SL.](http://www.proycontec.es/proycontec-3-iconos-gratis-index-es.html) - [Creative Commons Attribution-Share Alike 3.0](http://creativecommons.org/licenses/by-sa/3.0/us/)
