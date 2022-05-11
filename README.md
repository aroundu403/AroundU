# AroundU
**Team Members:**
| Name | Role |
| --- | --- |
| George Ma | Product Manager |
| Wei Wu | UI/UX Developer, Backend Developer |
| Wenxin Zhang | Frontend Developer, Backend Developer |
| John Wang | Frontend Developer, Deployment Developer |
| Melody Zhang | Frontend Developer |
| Vandy Zhang | Frontend Developer |

**Project Summary**:

> A platform for college student to post and find events within the university community。

**Project Description:**

Our goal is to allow user(students) more easy to find events or activities around them, and build connection or friendship with other through those events. With that idea, we believe that an interactive map-based interface would be a good approach to communicate with the user, and encourage user to attend events around them. As almost all in-person events or activity are naturally associate with a location, it is more intuitive for the user to found what events are available in a map. Beside that, map can also be a media that connect the virtual contents to the reality, giving the user a sense of authenticity and trust, which is commonalty lacking in todays social media.

**Main features:**

1. Register and validate user account: User can create an account via Email
2. Create an event or activity: User able to create/post an event by filling out some require info, like event title, time, size, public/private, and location. etc.
3.  Join or leave an event or activity: User should able to join or leave a specific selected event or activity.
4. Manage events/activities: Event initiator is able to edit the event details, like change time and event size. 
5. Interactive map-based interface: Display the events/activities in an interactive map-based interface. Allowing the user to interactive with the map element to preform verity of task like see, found, and join specific event or activity.  


**Prototype Use case**
- Actor: User
- precondition: A new User first download our app and want to find a event that neer him to participate
- Postconditions: the user successfully joins an event that interested him the most.
- List of step:
    1. register a account with Email address
    1. Enter to the Map View home page
    2. interact with the Map, and discover events on the map
    3. click on an event that interested him the most
    4. look at the event info on the event detail page
    5. click on the [join event botton] to join the event

- Internal Implementation
    1. our Account System utilizes Firebase API to connect the frontend and backend, allowing the user account info safely and securely transfer and store encrypted in our database. 
    2. Our Map View is powered by the Mapbox framework, which allows users to interact with the real-world map. 
    3. We implemented an Event API, which fetches all event data around the user's physical location from our database, then displays them on the map.
    4. Each event has detailed information including location, time, size, description, etc
    5. We implemented a join event API, which will update the selected event in our database.

## Repository Layout
1. ~/report: all the weekly status report
2. ～/src: the main code base
3. ......
