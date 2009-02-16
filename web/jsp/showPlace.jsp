<%--
   Openbravo POS is a point of sales application designed for touch screens.
   Copyright (C) 2007-2009 Openbravo, S.L.
   http://sourceforge.net/projects/openbravopos

    This file is part of Openbravo POS.

    Openbravo POS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Openbravo POS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Openbravo POS.  If not, see <http://www.gnu.org/licenses/>.
 --%>

<%-- 
    Document   : showPlace
    Created on : Nov 11, 2008, 5:38:14 PM
    Author     : jaroslawwozniak
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"
        import="java.util.List, com.openbravo.pos.ticket.ProductInfoExt"%>
<%@ taglib prefix="html" uri="http://jakarta.apache.org/struts/tags-html" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="javascript; charset=UTF-8">
        <meta name = "viewport" content = "width = 240">
        <LINK REL=StyleSheet HREF="layout.css" TYPE="text/css" MEDIA=screen>
        <script type="text/javascript" src='tableScript.js'></script>
        <script type="text/javascript" src='a.js'></script>
        <title>JSP Page</title>
     </head>
    <body>
        <div class="logo">
            <img src="images/logo.gif" alt="Openbravo" class="logo"/><br>
            <jsp:useBean id="products" type="List<ProductInfoExt>" scope="request" />
            <jsp:useBean id="place" type="java.lang.String" scope="request" />
            <jsp:useBean id="floorName" type="java.lang.String" scope="request" />
            <jsp:useBean id="floorId" type="java.lang.String" scope="request" />
            <a href='showFloors.do?floorId=${floorId}'><img alt="back" src="images/back.png" class="back"></a><%=floorName%><br>
        </div>
        <div class="middle">
            <table border="0" id="table" class="pickme">
                <thead>
                    <tr>
                        <th class="name">Item</th>
                        <th class="normal">Price</th>
                        <th class="normal">Units</th>
                        <th class="normal">Value</th> 
                        <th></th>
                        <th></th>
                        <th></th>
                </thead>
                <tbody>
                    <div id="products" >
                        <c:forEach var="line" items="${lines}" varStatus="nr">
                            <tr>                           
                                <td class="name">${products[nr.count - 1].name}</td>
                                <td class="normal"><fmt:formatNumber type="currency" value="${line.price}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                <td class="normal" id="mul${nr.count - 1}"><fmt:formatNumber type="number" value="${line.multiply}" maxFractionDigits="2" minFractionDigits="0"/></td>
                                <td class="normal" id="value${nr.count - 1}"><fmt:formatNumber type="currency" value="${line.value}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                <td><a href="#" onclick="ajaxCall(3, '${place}', '${nr.count - 1}');"><img src="images/plus.png" alt="add" class="button" /></a></td>
                                <td><a href="#" onclick="ajaxCall(1, '${place}', '${nr.count - 1}');"><img src="images/minus.png" alt="remove" class="button" /></a></td>
                                <td><a href="#" onclick="getIndexBackByEditing('${nr.count -1}', '${place}');"><img src="images/star.png" alt="multiply" class="button" /></a></td>
                            </tr>                            
                        </c:forEach>
                    </div>

                </tbody>
            </table>
       
        <br>
        <br>
            <input name="place" value="Add" type="submit" onclick="window.location='showProducts.do?place=${place}'" style="width:100px;">
        </div>

    </body>
</html>
