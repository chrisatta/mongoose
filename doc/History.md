# MongooseIM history

## 2011: Fork of ejabberd

MongooseIM's birthplace is a private Erlang Solutions' branch of ProcessOne's ejabberd - an XMPP/Jabber server written in Erlang.
What would later become a leading, highly customisable and scalable XMPP platform, originated in a strong idea - storing all internal strings in binaries instead of lists, among other significant improvements.

The change was introduced in 0.1.0 proto-MongooseIM release and 3.0.0-alpha-X series of ejabberd.
This opened the door for achieving higher performance, lower latency and introducing other subsequent improvements building up to a platform we are truly proud of.

### Initial differences from the parent project

This project began its life as a fork of ejabberd v.2.1.8, and later underwent major cleanup, refactoring and optimization:

*   Bringing the project source tree to compliance with OTP project structure recommendations
*   Swapping `autotools` for the Erlang community-standard build tool `rebar`
*   Removal of obsolete and/or rarely used modules to reduce maintenance burden
*   Reduction of runtime memory consumption by refactoring the code
    to use Erlang's binary data type for string manipulation and storage
    instead of operating on linked lists of characters
*   Functional test coverage of the system according to corresponding
    RFCs and XEPs

## 2012-2015: Fully independent project growing fast

The next steps were achieving full OTP and `rebar` compliance, removal of obsolete and/or rarely used modules, reduction of the runtime memory consumption and functional test coverage. 
[MongooseIM 1.0.0](https://github.com/esl/MongooseIM/releases/tag/1.0.0) was released on July 10th of 2012.

MongooseIM XMPP server fully independently went through multiple versions, following its own path with its own resources: [1.1.x](https://github.com/esl/MongooseIM/releases/tag/1.1.0) in 2012, [1.2.x](https://github.com/esl/MongooseIM/releases/tag/1.2.0) in 2013, [1.3.x](https://github.com/esl/MongooseIM/releases/tag/1.3.0), [1.4.x](https://github.com/esl/MongooseIM/releases/tag/1.4.0),  [1.5.x](https://github.com/esl/MongooseIM/releases/tag/1.5.0) in 2014, and [1.6.x](https://github.com/esl/MongooseIM/releases/tag/1.6.0) in 2015.

## 2016: Pivot to fullstack messaging platform

MongooseIM Platform appeared in 2016, with the release of [MongooseIM XMPP server 2.0.0](https://github.com/esl/MongooseIM/releases/tag/2.0.0).

The MongooseIM platform components were:

* MongooseIM XMPP server, featuring a unique REST API for client developers and MUC light
* [WombatOAM](https://www.erlang-solutions.com/capabilities/wombatoam/), for monitoring and operations
* [escalus](https://github.com/esl/escalus), an Erlang XMPP client for test automation
* [amoc](https://github.com/esl/amoc), for load generation
* [Smack](https://github.com/igniterealtime/Smack) for Android in Java (third party)
* [XMPPFramework](https://github.com/robbiehanson/XMPPFramework) for iOS in Objective-C (third party)
* [Retrofit](https://square.github.io/retrofit/) by Square for Android in Java (third party)
* [Jayme](https://github.com/inaka/Jayme) by Inaka for iOS in Swift

## 2017: Platform expansion and strengthening

We also introduced some MongooseIM platform components that are independent of the XMPP server.
So far the list includes:

* [Mangosta iOS](https://github.com/esl/mangosta-ios)
* [Mangosta Android](https://github.com/esl/mangosta-android)
* [MongoosePush](https://github.com/esl/mongoosepush)
* [MongooseICE](https://github.com/esl/MongooseICE)

## 2018-2019: Global distribution ready

The next step on our journey with the MongooseIM platform was to enable building global scale architectures.
This was necessary to welcome the massive influx of users that come with a full stack IoT and chatbot solution.

Erlang Solution's goal is to utilise XMPP features suited for chatbots, and build open standards for the completeness of our solution.

## 2020-2021: Friendly, cloud-native and dynamic

With the new configuration format, improved logging, and many more changes, MongooseIM has become more friendly for DevOps than ever before.
This goes hand in hand with the prioritisation of solutions that enable MongooseIM to be easily deployed to the cloud.

Whether in the cloud or on-premise, it is now possible to have a multi-tenant setup, powered by the new dynamic XMPP domains feature.
It means thousands of domains can be simply set up, managed, and removed dynamically, without a noticeable performance overhead.
