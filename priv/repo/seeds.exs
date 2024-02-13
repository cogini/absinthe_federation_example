# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AbsintheFederationExample.Repo.insert!(%AbsintheFederationExample.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AbsintheFederationExample.News.Link
alias AbsintheFederationExample.Repo

Repo.insert!(%Link{url: "http://graphql.org/", description: "The Best Query Language"})
Repo.insert!(%Link{url: "http://dev.apollodata.com/", description: "Awesome GraphQL Client"})
