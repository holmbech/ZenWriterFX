/*
 * TextEditor.fx
 *
 * Created on Mar 15, 2010, 11:10:07 AM
 */

package zen.like;

import javafx.scene.Node;
import javax.swing.JScrollPane;
import javafx.ext.swing.SwingComponent;
import javax.swing.border.EmptyBorder;
import java.awt.Insets;
import javafx.scene.text.Font;
import javafx.scene.paint.Color;
import javax.swing.JTextPane;
import java.io.File;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.StringBuilder;
import java.io.FileNotFoundException;

public class TextEditor {
    public-read var node: Node;
    public-read var textPane: JTextPane;
    public var file: File;
    public function save(): Void {
        def s = textPane.getText();
        if (s != null) {
            var output =
                    new OutputStreamWriter(new FileOutputStream("foo.txt"), "UTF-8");
            output.write(s.toString());
            output.close();
        }
    }

    public function load(ignore: Boolean): Void {
        try {
            def input = new BufferedReader(new InputStreamReader(new FileInputStream("foo.txt"), "UTF-8"));
            def sb = new StringBuilder();
            var line : String;
            while((line = input.readLine()) != null) {
                sb.append(line).append("\n");
            }
            input.close();
            textPane.setText(sb.toString());
        } catch (fnfe: FileNotFoundException) {
            if (ignore) {
                return;
            } else {
                throw fnfe;
            }
        }
    }
}

function awtToFx(font: javafx.scene.text.Font): java.awt.Font {
    font.impl_getNativeFont() as java.awt.Font;
}

function awtToFx(color: javafx.scene.paint.Color): java.awt.Color {
    color.impl_getPlatformPaint() as java.awt.Color;
}

public function create(font: Font, textColor: Color, selectionColor: Color,
        selectionTextColor: Color, onKeyPressed: function(): Void): TextEditor {
    var textPane = new AntiAliasedTextArea();

    var scrollPane = new JScrollPane(textPane);
    scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);
    scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
    var text: SwingComponent = SwingComponent.wrap(scrollPane);
    textPane.setBackground(new java.awt.Color(0,0,0,0)); // 0 opacity => 100% transparent!
    def awtTextColor = awtToFx(textColor);
    textPane.setForeground(awtTextColor);
    textPane.setCaretColor(awtTextColor);
    textPane.setSelectionColor(awtToFx(selectionColor));
    textPane.setSelectedTextColor(awtToFx(selectionTextColor));

    scrollPane.setOpaque(false);
    scrollPane.setBorder(new EmptyBorder(new Insets(0,0,0,0)));
    textPane.setFont(awtToFx(font));
    FX.deferAction(function() { // Ewwwww
        textPane.requestFocus();
    });

    def keyListener = KeyListener { onKeyPressed: onKeyPressed };
    textPane.addKeyListener(keyListener);
    
    TextEditor { node: text, textPane: textPane, file: new File("TheZenWriterFile.txt") }
}

class KeyListener extends java.awt.event.KeyAdapter {
    public-init var onKeyPressed: function(): Void;
    override function keyPressed(e) {
        onKeyPressed()
    }

}
