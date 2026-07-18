# LoopBikes JSP Project

Buy, Sell & Finance second hand bikes — Nagercoil, Tirunelveli, Tuticorin region.

## Folder Structure

```
bike/
├── loopbikes/              ← JSP web app (deploy to Tomcat)
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── classes/        ← All Java beans & servlets (source)
│   ├── assets/css/theme.css
│   ├── index.jsp, login.jsp, sell-bike.jsp, finance.jsp, about.jsp
│   ├── bikes/              ← Browse & detail pages
│   ├── user/               ← My requests, wishlist
│   └── admin/              ← Admin panel
└── uploadImages/           ← Bike images (OUTSIDE loopbikes folder)
    └── bike-images/YYYY/MM/
```

## Database Setup

1. Create database: `CREATE DATABASE loopbikes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
2. Run: `loopbikes/database/loopbikes_schema.sql`

## Tomcat JNDI Setup

Add to Tomcat `context.xml` or `{TOMCAT}/conf/Catalina/localhost/loopbikes.xml`:

```xml
<Context docBase="D:/MYFILES/bike/loopbikes" path="/loopbikes">
  <Resource name="jdbc/loopbikesdb"
            auth="Container"
            type="javax.sql.DataSource"
            maxTotal="20" maxIdle="5"
            username="root" password="YOUR_PASSWORD"
            driverClassName="com.mysql.cj.jdbc.Driver"
            url="jdbc:mysql://localhost:3306/loopbikes?useSSL=false&amp;serverTimezone=Asia/Kolkata"/>
</Context>
```

Copy `mysql-connector-j-8.x.jar` to `loopbikes/WEB-INF/lib/`

## Compile Java Classes

Compile all `.java` files in `WEB-INF/classes/` to `.class` files in same package folders.

Default admin login:
- Phone: `9876543210`
- Password: `admin123`

## Image Upload

Images stored at: `D:/MYFILES/bike/uploadImages/bike-images/YYYY/MM/`
Served via: `/loopbikes/uploadImages/bike-images/...`

## Pages

| Page | URL |
|------|-----|
| Home | /loopbikes/index.jsp |
| Buy Bikes | /loopbikes/bikes/browse.jsp |
| Sell Bike | /loopbikes/sell-bike.jsp |
| Finance | /loopbikes/finance.jsp |
| Admin | /loopbikes/admin/dashboard.jsp |
