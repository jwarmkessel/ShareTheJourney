Share the Journey
=================

Share the Journey is one of the first five apps built using [ResearchKit](https://github.com/ResearchKit/ResearchKit).

Our goals are to understand the causes of the symptom variations after
breast cancer treatment; to learn how mobile devices and sensors can
help us to these symptoms and their progression; and to ultimately
improve the quality of life for people after breast cancer treatment.

The Share the Journey app asks the participant to answer questions
about herself, medical history, and current health. The app also
collects information while the participant perform specific tasks
while using a mobile phone, such as to provide a journal about her
symptoms. Additionally, the app asks permission to collect sensor
data from the phone itself.


Building the App
================

###Requirements

* Xcode 6.2
* iOS 8.2 SDK

###Getting the source

First, check out the source, including all the dependencies:

```
git clone --recurse-submodules git@github.com:ResearchKit/ShareTheJourney.git
```

###Building it

Open the project, `BreastCancer.xcodeproj`, and build and run.


Other components
================

The shipping app also uses OpenSSL to add extra data protection, which
has not been included in the published version of the AppCore
project. See the [AppCore repository](https://github.com/researchkit/AppCore) for more details.
