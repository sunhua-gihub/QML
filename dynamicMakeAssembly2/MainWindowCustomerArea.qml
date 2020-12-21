/**
 * 主窗口程序的客户区组件文件

 * 子组件
 * li   创建测试子窗口按钮
 * li   销毁测试子窗口按钮
 */
import QtQuick 2.0
import QtQml.Models 2.12
import QtQuick.Controls 2.5

Rectangle {

    property int __tempTestWindowObjectIdentity: 0
    property var __tempTestWindowObject

    ListModel {

        id: id_listTestWindowTitleModel

        /**
            \biref  删除id值为 $windowId 的元素值
        */
        function removeItem(windowId) {

            for(var i = 0; i < id_listTestWindowTitleModel.count; ++i) {

                if(String("%1").arg(id_listTestWindowTitleModel.get(i).text) === String("%1").arg(windowId)) {

                    id_listTestWindowTitleModel.remove(i)
                }
            }
        }
    }

    // 客户区组件id声明
    id: id_rectMainWindowCustomerArea

    // 填充主窗口的客户区域
    anchors.fill: parent

    // 信号声明

    // 创建一个测试窗口
    signal makeTestWindow()

    // 销毁测试子窗口
    signal destroyedTestWindow()

    // 链接测试子窗口销毁对象信号声明
    signal linkDestroyedTestWindow(var windowId)

    // 查找测试子窗口对象
    signal linkFindTestWindowObject(var object,var windowId)

    // 拷贝 TestWindow 对象实例
    signal copyTestWindowExample(var windowId)

    // 修改测试子窗口风格
    signal modifyStyle(var windowId)

    Button { // 创建测试子窗口按钮

        id: id_btnMakeTestWindow
        text: "Make"
        anchors.left: id_rectMainWindowCustomerArea.left
        anchors.bottom: id_rectMainWindowCustomerArea.bottom
        onClicked: {

            id_rectMainWindowCustomerArea.makeTestWindow()
        }
    }

    Button { // 销毁测试子窗口按钮

        id: id_btnDestroyedTestWindow
        text: "Destroyed"
        anchors.right: id_rectMainWindowCustomerArea.right
        anchors.bottom: id_rectMainWindowCustomerArea.bottom
        onClicked: {

            id_rectMainWindowCustomerArea.destroyedTestWindow()
        }
    }

    Button { // 修改测试子窗口的风格

        id: id_btnModifyTestWindowStyle
        text: "Modify"
        onClicked: {

            // console.log("Button::Modify ")
            if(id_rectMainWindowCustomerArea.__findTestWindowObject(Number(id_comboBox.currentText)) !== null) {

                id_rectMainWindowCustomerArea.modifyStyle(Number(id_comboBox.currentText))
            }
        }
    }

    ComboBox { // 动态枚举修改风格得测试子窗口目标

        id: id_comboBox
        anchors.left: id_btnModifyTestWindowStyle.right
        editable: true
        model: id_listTestWindowTitleModel
        onAccepted: {
            if (find(editText) === -1)
                id_listTestWindowTitleModel.append({text: editText})
        }
    }

    onMakeTestWindow: {

        var retval = __makeTestWindow(__tempTestWindowObjectIdentity + 1)
        if(retval === true) {

            ++__tempTestWindowObjectIdentity
        }
        // console.log("onMakeTestWindow :" + retval)
    }

    onDestroyedTestWindow: {

        var retval = __destroyedTestWindow(__tempTestWindowObjectIdentity)
        if(retval === true) {

            --__tempTestWindowObjectIdentity
        }
        // console.log("onDestroyedTestWindow :" + retval)
    }

    /**
        \biref  创建一个测试窗口
        \param  子窗口窗口id

        \return 成功true，失败false
    */
    function __makeTestWindow(windowId) {

        var component = Qt.createComponent("TestWindow.qml");
        if (component.status === Component.Ready) {

            // 新建立的窗口应该是没有父级的，所以指定父级为 null
            var newWindow = component.createObject(null)

            // 设置新建立的窗口样式
            newWindow.width = 300
            newWindow.height = 300
            newWindow.__identity = windowId
            newWindow.title = "子窗口: " + newWindow.__identity

            // 关联新建立的窗口的数据传输通道
            linkFindTestWindowObject.connect(newWindow.findWindowIdentity)
            linkDestroyedTestWindow.connect(newWindow.destroyedWindow)
            modifyStyle.connect(newWindow.modifyStyle)

            // 记录创建的子窗口
            id_listTestWindowTitleModel.append({ text: String("%1").arg(newWindow.__identity) })
            return true
        }
        return false
    }

    /**
        \biref  销毁一个测试窗口
        \param  子窗口窗口id

        \return 成功true，失败false
    */
    function __destroyedTestWindow(windowId) {

        console.log(String("function __destroyedTestWindow(%1)").arg(windowId))

        if(__findTestWindowObject(windowId) !== null) {

            // console.log("__tempTestWindowObject !== null")
            linkDestroyedTestWindow(windowId)
            id_listTestWindowTitleModel.removeItem(windowId)
            return true
        }
        // console.log("__tempTestWindowObject === null")
        return false
    }

    /**
        \biref  重置测试子窗口实例句柄
        \param  目标实例句柄
    */
    function __resetTempTestWindowObject(object) {

        __tempTestWindowObject = object
    }

    /**
        \biref  查询是否存在测试子窗口实例存在
        \param  测试子窗口身份证

        \return null没有实例存在，否则有实例存在
    */
    function __findTestWindowObject(windowId) {

        __resetTempTestWindowObject(null)
        linkFindTestWindowObject(this, windowId)
        return __tempTestWindowObject
    }
}
