# PhotographyLessons

This repository contains a tiny app that allows users to pick a lesson from a list and watch it in the details view. The users also have the ability to download and watch the lessons offline. 

### Lessons list screen
- Implemented using SwiftUI
- Shows a title and a thumbnail image and name for each lesson
- List of lessons is fetched when opening the application (from URL or local cache when no connection).

### Lesson details screen
- Implemented programmatically using UIKit
- Includes a "Download" button to start the download for offline viewing
- Includes a "Cancel download" button and a progress bar while the video is downloading
- Video is displayed in full screen when the app rotates to landscape. 

## Screenshots
|   |   |   |
|---|---|---|
| ![image1](Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-02-06%20at%2009.54.41.png)  | ![image2](Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-02-06%20at%2009.56.13.png) | ![image3](Simulator%20Screen%20Shot%20-%20iPhone%2014%20Pro%20-%202023-02-06%20at%2009.57.10.png) |

## Testing

Unit and UI automated tests are written using XCTest. These tests cover important functionality of the app. MockURLSession and FakeUserDefaults created for testing purposes.



