# BuddyConnect

[![Swift Version](https://img.shields.io/badge/Swift-4-ED4731.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-2-F6CBCA.svg)](http://vapor.codes)

`master`:
[![Circle CI](https://circleci.com/gh/nodes-projects/buddyconnect-vapor/tree/master.svg?style=shield&circle-token=2623ea588007ff02bca4e86f411d3827adee2e20)](https://circleci.com/gh/nodes-projects/buddyconnect-vapor)
[![codebeat badge](https://codebeat.co/badges/b6601dfa-0033-4be5-b540-ef2262c72894)](https://codebeat.co/a/tech-2/projects/github-com-nodes-projects-buddyconnect-vapor-master)

`develop`:
[![Circle CI](https://circleci.com/gh/nodes-projects/buddyconnect-vapor/tree/develop.svg?style=shield&circle-token=2623ea588007ff02bca4e86f411d3827adee2e20)](https://circleci.com/gh/nodes-projects/buddyconnect-vapor)
[![codebeat badge](https://codebeat.co/badges/d6e74724-850a-4123-a54f-a5fb87f2280f)](https://codebeat.co/a/tech-2/projects/github-com-nodes-projects-buddyconnect-vapor-develop)

## 📖 Project description
Backend (API and AdminPanel) for the BuddyConnect app. The application let users vote their well-being. It also provides information about themselves and their buddy. The AdminPanel is used for inviting users to the app.

## 🔧 Installation
To get the project up and running you can follow the usual steps:

- `vapor update`
- `vapor xcode`

The project uses AdminPanel and to get a user, you can use the seeder:

- `vapor build`
- `vapor run admin-panel:seeder`

Alternatively you can edit the `App` scheme and add `admin-panel:seeder` as an argument passed on launch.

This project uses Sourcery for code generation. If you're making changes to the parts of the codebase where Sourcery is used, remember to install and run Sourcery each time you do changes:

- `brew install sourcery`
- `sourcery`

Make sure to have your environment variables set up. Have a look here for a guide on [how-to](https://github.com/nodes-vapor/readme/blob/master/Documentation/how-to-setup-environment-variables.md). And the here for some [shared credentials](https://github.com/nodes-projects/readme/blob/master/server-side/vapor/environment-variables.md).

## 🏯 Architecture & code principles
This project overall follows the official documentation for writing Vapor projects. This project uses our [Sourcery templates](https://github.com/nodes-vapor/sourcery-templates) to generate parts of the codebase. It was developed in Express-Mode.

## 👌 Tests
This project has no tests.

## 🔗 Useful links
- [Project documentation report](https://docs.google.com/document/d/1SilSuEef27jm6SEDicGcAQLii7ocSKR0vbC0x1hRkaI/edit)
- [Trello Board]()

## 💻 Developers
- @mala

## Project Manager
- @likn
