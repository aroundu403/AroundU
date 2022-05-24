# User Documentation

## Application description

AroundU is a platform that allow you to find or post interesting events or activity in your neighborhood. As we spend
more and more time in the digital world, we missed out on a lot of people and things around our neighborhood. Have you
consider put down your phone on the weekend and go have fun with people who living next to you? That is exactly how we
build relationship with others in the old days. So now join a event in AroundU, and go out and have fun!

## How to install AroundU

Simply visit [https://aroundu-403.web.app/#/](https://aroundu-403.web.app/#/) to access the web version

You will only need Chrome browser and internet access to access the web-application. To learn more about building the
software and dependencies, go to `/frontend/README.md`.

## How to use AroundU

In AroundU, you can be an event participant or an event creator.

- As an event participant:

  feeling boring on a weekend? want to find some think to do or meet some new people?

    - In the Home Page(Map View), you can find all the ongoing or upcoming event around your current location.
    - pick one that sound interesting to you, click on it. you will enter the event details page. Check out the event
      description and other event info
    - getting excited about the event? Just click on the button <Join Event>, then you are in.
    - You can also click on the MyEvent in the bottom left corner on the Home page to find all the event you have joined
- As an event creator:

  Don’t find the right event on the Map? Why not just hold your own event and invite people around you?

    - You can click on the <Create button> located on the bottom of the home page, it will lead you to the event create
      page.
    - Upload a pic for your event, name it an interesting title, fill out the event info like time, location and size.
    - After filling out all the event info, just simply click the <publish button>, Then you are all set.
    - You can share your event with your friends with the unique event code, so they can find and join your event in
      AroundU.
    - You can also click on the MyEvent in the bottom left corner on the Home page to find all the event you have
      created.

## Found something wrong with AroundU?

As a newly started platform, we are working hard to provide you the best experience as we can.

If you find something wrong or would like to give us suggestion, head
to: [https://github.com/aroundu403/AroundU/issues](https://github.com/aroundu403/AroundU/issues)

Please include the following information, so we can better locate the bug:

- an description summary of what goes wrong
- Which platform you are using?
- Which page you see the issue?
- What kinds of issue? Application Crashed? Rendering Error? Functional Issue?
- Steps to reproduce the bug:
    - What are the list of steps that leads you to issue?
    - Is the error repeatable?
    - List out the steps to guide us to find the bug!
- What are you expecting?
- What actually happened?

After you submit a new issue, our team will do our best to investigate and give you respond as soon as possible.

## Known issues

1. When first enter into the map view, user current location was not shown. Have to manually click the recenter button
   to show user location icon.
2. The front end is partially relies on mock data and isn't fully connected to backend. Some states wouldn't be
   persisted to backend.
3. The image picker in create event page currently isn't support on web version since the underlying library only supports iOS and Andriod.
4. To use the data and time pikcer on web version, use two fingers to scroll the screen.