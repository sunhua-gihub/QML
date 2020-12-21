import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

ApplicationWindow {

    property int __identity: 0
    id: id_testtingWindow
    visible: true
    width: 640
    height: 480

    // 尝试销毁测试子窗口组件信号
    signal tryDestroyedThis(var identity)

    // 提示文本信息
    Text {

        anchors.centerIn: parent
        id: id_text
        text: qsTr("这是一个测试子窗口")
    }

    onTryDestroyedThis: {

        if(identity === __identity) {

            console.log("onDestroyedThis:" + close())
        }
    }

    /**
        \biref  改变风格，如果是默认风格，那么这个窗口将变成红色风格，如果是红色风格，那么
                它将会变成默认风格
        \param  窗口id
    */
    function modifyStyle(windowId) {

        if(windowId === __identity) {

            /**
                \bug    color === "#ffffff" 返回值为 false,但是 color 的值输出是 "#ffffff"
            */
            var str_color = String("%1").arg(color)
            var str_white = String("%1").arg("#ffffff")
            var str_red = String("%1").arg("#ff0000")

            if(str_color === str_white) {
                // console.log("color === white_color");
                color = str_red
            }

            if(str_color === str_red) {
                // console.log("color === red_color");
                color = str_white
            }
        }
    }

    /**
        \biref  查找目标id值得测试子窗口
        \param  [out] 外部管理对象
        \param  [in] 测试子窗口id
    */
    function findWindowIdentity(object, identity) {

        // console.log("TestWindow.qml " + String("identity(%1) === __identity(%2)").arg(identity).arg(__identity))
        if(identity === __identity) {

            // 将目标值拷贝到外部管理对象得缓冲区
            object.__tempTestWindowObject = this
        }
    }

    function destroyedWindow(identity) {

        // console.log("TestWindow.qml >>destroyedWindow " + String("identity(%1) === __identity(%2)").arg(identity).arg(__identity))
        tryDestroyedThis(identity)
    }
}
