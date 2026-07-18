JCreator compile setup (Tomcat 10.1)
====================================

1. Add this JAR to your JCreator project library/classpath:
   WEB-INF/lib/servlet-api.jar
   (copied from Tomcat 10.1 - Jakarta EE, NOT javax)

2. All servlet/filter code uses jakarta.servlet.* (Tomcat 10+)

3. Compile all .java files under WEB-INF/classes/

4. Do NOT deploy mysql-connector or servlet-api duplicates if Tomcat already provides them.
   servlet-api.jar here is mainly for JCreator compile.
