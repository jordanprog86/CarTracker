import QtQuick 2.5
import QtQuick.Window 2.2
import QtPositioning 5.3
import QtLocation 5.3
Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("CarTracker")
    property int tryCount: 0;
    property double lastLon;
    property double lastLat;
    property double fLon;
    property double ftLat;
    property variant lastCoord;
    property variant firstCoord;
    property variant prevPath;
    property variant nextPath;
    id:app


    Map{

        id:map
        anchors.fill: parent
        Text {
            id: author
            text: qsTr("By Jordan Tchoulayeu")
            font.pointSize: 12
            anchors.bottom: parent.bottom
            anchors.right: parent.right

        }
        MapPolyline {
                  line.width: 5
                  line.color: 'lightblue'
                  id:polLyne
              }
        center: QtPositioning.coordinate(-27, 153.0 )
        onZoomLevelChanged: console.log(map.zoomLevel)

        zoomLevel:16.279999999999994
        minimumZoomLevel: 0
        maximumZoomLevel: 100

        plugin: Plugin
        {
        name:"here"
        PluginParameter{name:"here.app_id";value:"AdlHDaG9arfXO34Q5043"}
        PluginParameter{name:"here.token";value:"0w7W6Pjn7p_dl-upNJ9aPQ"}
        }
          MapQuickItem {
          id: marker
          anchorPoint.x: image.width/2
          anchorPoint.y: image.height/2
          coordinate:QtPositioning.coordinate(3.8666700
                                              , 11.5166700)

          sourceItem: Image {
              id: image
              source: "qrc:/car.png"
              width: 30
              height: 55
          }
      }
    }
PositionSource
{
    id: src
    updateInterval: 1000
    active: true
    preferredPositioningMethods: PositionSource.AllPositioningMethods
    onPositionChanged:
    {
if(app.tryCount == 0)
{
    map.center= src.position.coordinate;
     marker.coordinate =src.position.coordinate;

    var coords= src.position.coordinate;
    app.ftLat = parseFloat(coords.latitude);
    app.fLon = parseFloat(coords.longitude);

    app.prevPath = QtPositioning.coordinate(-app.ftLat, app.fLon);

    app.firstCoord = QtPositioning.coordinate(app.ftLat, app.fLon);
    app.tryCount++;
}
else
   {
    var coord = src.position.coordinate;
    app.lastLat = parseFloat(coord.latitude);
    app.lastLon = parseFloat(coord.longitude);
    app.nextPath = QtPositioning.coordinate(-app.lastLat, app.lastLon);

    if(app.tryCount ==1)
    {
        polLyne.addCoordinate(app.prevPath);
    }
    else
    {

    }

    polLyne.addCoordinate(app.nextPath);
    rot.from = QtPositioning.coordinate(app.ftLat, app.fLon);
    rot.to = app.firstCoord.azimuthTo(QtPositioning.coordinate(app.lastLat, app.lastLon));
    trans .from =  rot.from = QtPositioning.coordinate(app.ftLat, app.fLon);
    trans.to = QtPositioning.coordinate(app.lastLat, app.lastLon);
    app.firstCoord = QtPositioning.coordinate(app.lastLat,app.lastLon);
    app.ftLat = app.lastLat;
    app.fLon = app.lastLon;
    app.tryCount++;
    vol.start();

}

    }
}
ParallelAnimation
{
 id:vol
 running: false
 NumberAnimation {
    target: marker;
     property: "rotation";
     duration:3000
     easing.type: Easing.InCubic
     id:rot

 }
CoordinateAnimation
{

 properties: "coordinate"
 target: marker
 duration:3000
 id:trans

}
onStopped:
{
map.center = src.position.coordinate;
}
}

    }

