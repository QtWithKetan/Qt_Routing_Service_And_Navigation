import QtQuick 2.15
import QtQuick.Window 2.15
import GeneralMagic 2.0
import QtQuick.Window 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Qt Routing And Navigation Service")

    property var updater: ServicesManager.contentUpdater(ContentItem.Type.RoadMap)
    Component.onCompleted:
    {
        ServicesManager.settings.allowInternetConnection = true

        updater.autoApplyWhenReady = true
        updater.update()
    }

    // Now Add two Points 1 = StartingPoint And 2 = Ending Point
    RoutingService
    {
        id:routingService
        type:Route.Type.Fastest
        transportMode: Route.TransportMode.Car
        waypoints: LandmarkList
        {
            Landmark
            {
                name:"Starting Point"
                coordinates: Coordinates
                {
                    latitude: 19.0760
                    longitude: 72.8777
                }
            }
            Landmark
            {
                name:"Ending Point"
                coordinates: Coordinates
                {
                    latitude: 28.7041
                    longitude: 77.1025
                }
            }
        }
        onFinished:
        {
            geomapview.routeCollection.set(routeList)
            geomapview.centerOnRouteList(routeList);
        }
    }

    // Now Let's Add NavigationService For Find The Path or Route And Compute The Data Like Distance And time
    NavigationService
    {
        id:navigationService
        route: geomapview.routeCollection.mainRoute
        simulation: true
        onActiveChanged:
        {
            if (active)
            {
                geomapview.startFollowingPosition()
                geomapview.routeCollection.clear(true)
            }
        }
    }

    // Let's Add MapView
    MapView
    {
        id:geomapview
        anchors.fill: parent
        viewAngle: 35
        cursorVisibility: false

        onRouteSelected:
        {
            routeCollection.mainRoute = route
            centerOnRoute(route)
            console.log("Selected Route Is : " + route.summary)
        }

        // Now Lets Find The Path Or routeCollection.

        Button
        {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            text:"Find The Path Or Route"
            enabled: ServicesManager.settings.connected && !navigationService.active
            onClicked: routingService.update()
        }

    }

}
