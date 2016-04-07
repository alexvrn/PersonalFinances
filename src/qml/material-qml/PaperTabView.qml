import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Controls.Private 1.0
import QtGraphicalEffects 1.0

FocusScope {
  id: root

  width: 100
  height: 100
  visible: true

  implicitWidth: 240
  implicitHeight: 150

  /*! The current tab index */
  property int currentIndex: 0
  /*! The current tab count */
  property int count: 0
  /*! The visibility of the tab frame around contents */
  property bool frameVisible: true
  /*! The visibility of the tab bar */
  property bool tabsVisible: true
  /*!
  \qmlproperty enumeration TabView::tabPosition
  \list
  \li Qt.TopEdge (default)
  \li Qt.BottomEdge
  \endlist
  */
  property int tabPosition: Qt.TopEdge

  //property alias content: viewArea.children

  property int current: tabBar.selectedIndex

  property color tabBackgroundColor: "#089795"
  property color tabTextColor: "white"
  property color highlightColor: "yellow"
  property int tabFontSize: 11
  property double cellHeight: dp(48)
  property double cellWidth: -1

  default property alias data: stack.data

  /*!
  This is the standard function to use for accessing device-independent pixels. You should use
  this anywhere you need to refer to distances on the screen.
  */
  // TODO - перенести в библиотеку
  function dp(number) {
    var __pixelDensity = 4.5 // pixels/mm
    return number * __pixelDensity * 1.4 * 0.15875
  }

  onCurrentChanged: __setOpacities()

  Component.onCompleted: __setOpacities()

  /*! Adds a new tab page with title with and optional Component.
  Returns the newly added tab.
  */
  function addTab(title, component) {
    return insertTab(__tabs.count, title, component)
  }

  function insertTab(index, title, component) {
    var tab = tabcomp.createObject(stack)
    tab.sourceComponent = component
    tab.parent = stack
    tab.title = title
    tab.__inserted = true
    __tabs.insert(index, {tab: tab})

    //for Title
    var tabTitle = []
    if(index > tabBar.tabs.length) {
        tabTitle = tabBar.tabs;
        tabTitle.push(title);
    }
    else {
      for(var i = 0; i < tabBar.tabs.length; ++i)
        if(i !== index)
          tabTitle.push(tabBar.tabs[i])
        else
          tabTitle.push(title)
    }
    tabBar.tabs = tabTitle

    __changeSize()
    __setOpacities()
    return tab
  }

  /*! Removes and destroys a tab at the given \a index. */
  function removeTab(index) {
    var tab = __tabs.get(index).tab
    __tabs.remove(index, 1)
    tab.destroy()
    if (currentIndex > 0)
      currentIndex--

    //for Title
    var tabTitle = [];
    for(var i = 0; i < tabBar.tabs.length; ++i)
      if(i !== index)
        tabTitle.push(tabBar.tabs[i])
    tabBar.tabs = tabTitle;

    __changeSize()
    __setOpacities()

  }

  /*! Moves a tab \a from index \a to another. */
  function moveTab(from, to) {
    __tabs.move(from, to, 1)
    if (currentIndex === from) {
      currentIndex = to
    }
    else {
      var start = Math.min(from, to)
      var end = Math.max(from, to)
      if (currentIndex >= start && currentIndex <= end) {
        if (from < to)
          --currentIndex
        else
          ++currentIndex
      }
    }

    //for Title
    var tabTitle = tabBar.tabs;
    var titleFrom = tabTitle[from]
    tabTitle[from] = tabTitle[to]
    tabTitle[to] = titleFrom
    tabBar.tabs = tabTitle

    __tabs.get(to).tab.x = to * stack.width;
    __tabs.get(from).tab.x = from * stack.width;
    __scrollTab(current)
  }

  /*! Returns the \l Tab item at \a index. */
  function getTab(index) {
    return __tabs.get(index).tab
  }

  function __setOpacities() {
    __scrollTab(current)
    count = __tabs.count
  }

  function __scrollTab(index)
  {
    page.x = -index*stack.width
  }

  function __changeSize() {
    for(var i = 0; i < __tabs.count; ++i) {
      var child = __tabs.get(i).tab;
      child.visible = true
      child.x = i*stack.width
      child.y = 0
      child.width = stack.width
      child.height = stack.height
    }
  }

  function __setParent() {
    for(var i = 0; i < __tabs.count; ++i)
      __tabs.get(i).tab.parent = page
  }

  property ListModel __tabs: ListModel { }

  property Component style: Qt.createComponent(Settings.style + "/TabViewStyle.qml", root)
  /*! \internal */
  property var __styleItem: loader.item

  activeFocusOnTab: false

  Component {
    id: tabcomp
    PaperTab {}
  }

  Item {
    id: page
    x: 0
    width: stack.width * __tabs.count//stack.width
    height: stack.height
    parent: stack

    Behavior on x { PropertyAnimation { duration: 350; easing.type: Easing.InOutQuad } }//InOutCirc InOutBack Easing.InOutExpo} }
  }

  TabBar {
    id: tabbarItem
    objectName: "tabbar"
    tabView: root
    style: loader.item
    anchors {
      top: parent.top
      left: root.left
      right: root.right
    }
  }

  PaperTabBar {
    id: tabBar
    backgroundColor: root.tabBackgroundColor
    tabTextColor: root.tabTextColor
    highlightColor: root.highlightColor
    height: root.cellHeight
    tabFontSize: root.tabFontSize
    cellWidth: root.cellWidth

    anchors.left: root.left
    anchors.right: root.right
    tabs: root.tabs
  }

  Loader {
    id: loader
    z: tabbarItem.z - 1

    property var __control: root
  }

  Loader {
    id: frameLoader
    z: tabbarItem.z - 1

    anchors.fill: parent
    anchors.topMargin: tabBar.height
    anchors.bottomMargin: tabPosition === Qt.BottomEdge && tabbarItem && tabsVisible ? Math.max(0, tabbarItem.height -baseOverlap) : 0
    sourceComponent: frameVisible && loader.item ? loader.item.frame : null
    property int baseOverlap: __styleItem ? __styleItem.frameOverlap : 0

    Item {
      id: stack
      anchors.fill: parent
      anchors.margins: (frameVisible ? frameWidth : 0)
      anchors.topMargin: anchors.margins + (style =="mac" ? 6 : 0)
      anchors.bottomMargin: anchors.margins
      height: root.height

      //Если меняем размеры компонента
      onWidthChanged: {
        __changeSize()
        __scrollTab(current)
      }
      onHeightChanged: {
        __changeSize()
      }

      clip:true//чтобы элемент page видно было только в пределах этого(stack) элемента

      property int frameWidth
      property string style
      Component.onCompleted: addTabs(stack.children)

      function addTabs(tabs) {

        var tabAdded = false
        var titles = [];  
        for (var i = 0 ; i < tabs.length ; ++i) {
          var tab = tabs[i]

          if (!tab.__inserted && tab.Accessible.role === Accessible.LayeredPane) {
            tab.__inserted = true
            if (tab.parent === root) {
              tab.parent = page
              // a tab added dynamically by Component::createObject() and passing the
              // tab view as a parent should also get automatically removed when destructed
              tab.Component.onDestruction.connect(stack.onDynamicTabDestroyed.bind(tab))
            }
            __tabs.append({tab: tab})
            titles.push(String(tab.title))
            tabAdded = true
          }
        }
        tabBar.tabs = titles;

        //Для всех закладок делаем родителя компонент - page
        __setParent()

        //changed parent
        __changeSize()

        if (tabAdded)
          __setOpacities()
      }

      function onDynamicTabDestroyed() {
        for (var i = 0; i < stack.children.length; ++i) {
          if (this === stack.children[i]) {
            root.removeTab(i)
            break
          }
        }
      }
    }
    onLoaded: { item.z = -1 }
  }

  onChildrenChanged: stack.addTabs(root.children)

  states: [
    State {
      name: "Bottom"
      when: tabPosition === Qt.BottomEdge && tabbarItem != undefined
      PropertyChanges {
        target: tabbarItem
        anchors.topMargin: -frameLoader.baseOverlap
      }
      AnchorChanges {
        target: tabbarItem
        anchors.top: frameLoader.bottom
      }
    }
  ]
}
