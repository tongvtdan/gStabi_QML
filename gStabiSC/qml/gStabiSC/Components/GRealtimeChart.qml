/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0

Rectangle {
    id: chart
    width: 700;     height: 250
    color: "transparent"

    property var settings

    function update() {
        canvas.requestPaint();
    }

    Text {
        id: titleLabel
        color: "cyan"
        width: 100
        height: 20
        wrapMode: Text.WordWrap
        anchors.top: parent.top
        text: "Realtime Chart"
        font.pixelSize: 14
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Canvas {
        id: canvas
        width: parent.width; height: parent.height - 20
        anchors.topMargin: 20
        anchors.top: titleLabel.top
//        renderTarget: Canvas.FramebufferObject
        renderTarget: Canvas.Image
        antialiasing: true
        property int frames: first
        property int mouseX: 0
        property int mouseY: 0
        property int mousePressedX: 0
        property int mousePressedY: 0
        property int movedY: 0
        property real scaleX: 1.0
        property real scaleY: 1.0
        property int first: 0
        property int last: 0
        property int pixelSkip: 1
        property int  offset: 0
        property int  draw_area_width: canvas.width-offset
        property int  draw_area_height: canvas.height-offset

        function drawBackground(ctx) {
            ctx.save();
            ctx.fillStyle = "transparent";
            ctx.fillRect(0, 0, draw_area_width, draw_area_height);
            ctx.strokeStyle = "cyan";
            ctx.beginPath();
        // horizontal grid lines
            for (var i = 0; i <= 10; i++) {
                ctx.moveTo(0, i * (draw_area_height/10.0));
                ctx.lineTo(draw_area_width, i * (draw_area_height/10.0));
            }
        // vertical grid lines
            for (i = 0; i <= 12; i++) {
                ctx.moveTo(i * (draw_area_width/12.0), 0);
                ctx.lineTo(i * (draw_area_width/12.0), draw_area_height);
            }
            ctx.stroke();

        // hightlight line
//            ctx.strokeStyle = "#5c7a37";
//            ctx.beginPath();
//            ctx.moveTo(8 * (draw_area_width/12.0), 0);
//            ctx.lineTo(8 * (draw_area_width/12.0), draw_area_height);
//            ctx.stroke();
            ctx.restore();
        }


        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.lineWidth = 1;
            drawBackground(ctx);


        }
    } // end of canvas
}
