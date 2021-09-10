# THIS PAGE IS NO LONGER RELEVANT FOR ANYTHING OTHER THAN HISTORICAL REFERENCE

Serber built by Ruby On Rails
See the repo wiki for up-to-date info.

# serve2perform

*Optimizing Group Performance by Cultivating Individual Potential*

## !!! Rails 4 Upgrade !!!

We are in the process of upgrading to Rails 4.0.13.  See the branch
`4-0-13-test` for progress.

## Development

### Bug Tracker

We are using Github Issues at the moment:
https://github.com/serve2perform/serve2perform/issues

### Starting the Application

To start the development environment, ensure that redis-server is
running (`ps uax|grep redis`) and fire off:
`bundle exec foreman start -f Procfile.dev`

### Deployment

serve2perform staging and production are on Heroku.

Production (`s2p-production`): `git@heroku.com:s2p-production.git`
Staging (`s2p-staging-rebuild`):  `git@heroku.com:s2p-staging-rebuild.git`

### Continuous integration

See http://magnum-ci.com
 
## Lexicon and Obscura

Development on serve2perform has moved quickly and was often cobbled
together as a learning excecise, therefore many strange associations
and repurposing of code has occured.  Here are a few examples.

## Lexicon

- Companies are Organizations intended to group users by their parent
company.  Users should have very few companies.
- UserGroups are used to represent "Groups"
- Inquiries are generally known as Questions on the frontend
- Best Practices are generally known as Insights on the frontend
- Fast Contents are generally known as Resources and often relate to
file uploads or links
- Opportunities have changed names several times.  They often
represent different things on the frontend
- PACs are known as "collaborations" or "collaboration groups".  The
original meaning of the acronym is lost to time

## GOTCHAS

### Deprecations

- Badges were associated with a year at one point and may not
currently be behaving as such
- Action Plans and Coach Action Plans are deprecated
- Automake Facility and Facilities are generally deprecated
- Coupons and Coupon Uses are deprecated
- Facilities are deprecated
- Feedbacks may be deprecated
- Industry may be deprecated
- Single User License is deprecated
- Video may be deprecated
- webcast_facilitator is deprecated
- US State and ZIP may be deprecated

### decent_exposure

We began the process of including `decent_exposure` in as many
controllers as possible but we didn't finish the job.  It should
be implemented as much as possible.

### Companies, Organizations, and Groups!  Oh My!

Currently, most aggregations of "Groups" associated with a User will
show their companies/organizations/usergroups.  This is done to
preserve historical data and needs to be sorted out.

### Buildpack

The production buildpack is deprecated.  See issue #553

### Constant build failures on magnum-ci

Our postgres backend is out of date on magnum-ci.  See issue #554

### chgems

Remeber to run `chgems` before attempting to execute any of the
binaries related to this project.

### local https redirects

If you get "Secure Connection Failed" when trying to access the
application locally, switch to HTTP.
