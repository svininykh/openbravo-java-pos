//    Openbravo POS is a point of sales application designed for touch screens.
//    Copyright (C) 2008 Openbravo, S.L.
//    http://www.openbravo.com/product/pos
//
//    This file is part of Openbravo POS.
//
//    Openbravo POS is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Openbravo POS is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.

package com.openbravo.pos.inventory;

import com.openbravo.basic.BasicException;
import com.openbravo.data.user.DirtyManager;
import com.openbravo.data.user.EditorRecord;
import com.openbravo.format.Formats;
import com.openbravo.pos.forms.AppLocal;
import java.awt.Component;
import java.util.UUID;

/**
 *
 * @author  adrianromero
 */
public class AttributeSetsEditor extends javax.swing.JPanel implements EditorRecord {

    private Object id;

    /** Creates new form AttributesEditor */
    public AttributeSetsEditor(DirtyManager dirty) {
        initComponents();

        m_jName.getDocument().addDocumentListener(dirty);

        writeValueEOF();
    }
    public void writeValueEOF() {
        id = null;
        m_jName.setText(null);
        m_jName.setEnabled(false);
    }
    public void writeValueInsert() {
        id = UUID.randomUUID().toString();
        m_jName.setText(null);
        m_jName.setEnabled(true);
    }
    public void writeValueDelete(Object value) {

        Object[] attrset = (Object[]) value;
        id = attrset[0];
        m_jName.setText(Formats.STRING.formatValue(attrset[1]));
        m_jName.setEnabled(false);
    }
    public void writeValueEdit(Object value) {

        Object[] attrset = (Object[]) value;
        id = attrset[0];
        m_jName.setText(Formats.STRING.formatValue(attrset[1]));
        m_jName.setEnabled(true);
    }

    public Object createValue() throws BasicException {

        Object[] attrset = new Object[2];

        attrset[0] = id;
        attrset[1] = m_jName.getText();

        return attrset;
    }

    public Component getComponent() {
        return this;
    }

    public void refresh() {
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel2 = new javax.swing.JLabel();
        m_jName = new javax.swing.JTextField();

        jLabel2.setText(AppLocal.getIntString("Label.Name")); // NOI18N

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 316, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(m_jName, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 43, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(m_jName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel2;
    private javax.swing.JTextField m_jName;
    // End of variables declaration//GEN-END:variables

}
