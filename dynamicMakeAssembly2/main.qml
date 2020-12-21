/**
*   测试 QML 动态创建组件程序实例

*   需求
*   1. 可以通过人机交互的方式动态创建测试子窗口
*   2. 可以通过人机交互的方式动态删除最后一个测试子窗口实例对象
*   3. 可以通过人机交互的方式动态改变并复原测试子窗口实例对象的风格
*/
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    MainWindowCustomerArea {

        id: id_mainWindowCustomerArea
    }
}
