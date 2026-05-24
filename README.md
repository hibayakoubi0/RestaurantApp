
# RestaurantApp — Guide de déploiement


## Configuration

1. Copier le fichier exemple :
cp src/main/resources/config.properties.example src/main/resources/config.properties

2. Remplir vos identifiants MySQL dans `config.properties`

3. Compiler et déployer :
mvn clean package
copy target\RestaurantApp.war C:\apache-tomcat-...\webapps\

## Prérequis

| Outil | Version recommandée |
|-------|-------------------|
| JDK | 17 ou 21 |
| Apache Tomcat | 10.1+ (Jakarta EE 10) |
| MySQL | 8.0+ |
| IDE | Eclipse IDE for Enterprise Java (ou IntelliJ) |

---

## 1. Base de données MySQL

```bash
mysql -u root -p < schema.sql
```

Cela crée la base `restaurant_db` avec les tables et quelques données de test.

---

## 2. Fichiers JAR à placer dans `WEB-INF/lib/`

### ① MySQL Connector/J (OBLIGATOIRE)
- Télécharger : https://dev.mysql.com/downloads/connector/j/
- Choisir **Platform Independent → ZIP**
- Extraire et copier **`mysql-connector-j-X.X.X.jar`** dans `WEB-INF/lib/`
- ⚠️ Le ZIP fourni dans le projet original contient le JAR — extrayez-le.

### ② Jakarta Servlet API (si hors Tomcat)
Si vous compilez en dehors de Tomcat, ajoutez aussi :
- `jakarta.servlet-api-6.0.0.jar`
- Disponible sur : https://mvnrepository.com/artifact/jakarta.servlet/jakarta.servlet-api

---

## 3. Configuration de la connexion MySQL

Modifiez `src/main/java/com/restaurant/util/DBConnection.java` :

```java
private static final String URL  =
    "jdbc:mysql://localhost:3306/restaurant_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
private static final String USER = "root";           // ← votre utilisateur MySQL
private static final String PASS = "VotreMotDePasse"; // ← votre mot de passe
```

---

## 4. Déploiement sur Tomcat

1. Importez le projet dans Eclipse : `File > Import > Existing Projects into Workspace`
2. Cliquez droit sur le projet → `Run As > Run on Server` → sélectionnez Tomcat 10.1
3. Accédez à : `http://localhost:8080/RestaurantApp/`

---

## 5. Structure du projet

```
RestaurantApp/
├── src/main/
│   ├── java/com/restaurant/
│   │   ├── model/         ← Entités (Plat, TableRestaurant, Commande…)
│   │   ├── dao/           ← Accès base de données (JDBC)
│   │   ├── servlet/       ← Contrôleurs HTTP
│   │   └── util/          ← DBConnection
│   └── webapp/
│       ├── index.jsp      ← Accueil
│       ├── tables.jsp     ← Gestion des tables
│       ├── menu.jsp       ← Gestion du menu
│       ├── commande.jsp   ← Commandes
│       ├── facture.jsp    ← Facture imprimable
│       └── WEB-INF/
│           ├── web.xml    ← Configuration servlet
│           └── lib/       ← mysql-connector-j.jar ici
└── schema.sql             ← Script création BDD
```

---

## 6. Bug corrigé : PlatServlet.jav → PlatServlet.java

Le fichier `PlatServlet.jav` avait une extension incorrecte. Il a été renommé en `PlatServlet.java` et un `serialVersionUID` a été ajouté.

---

## 7. Fonctionnalités

- ✅ Gestion des tables (CRUD, statuts LIBRE/OCCUPEE/RESERVEE)
- ✅ Gestion du menu par catégorie (ENTREE/PLAT/DESSERT/BOISSON)
- ✅ Création de commandes avec sélection de plats et quantités
- ✅ Mise à jour des statuts de commande
- ✅ Génération de factures (HT + TVA 20% = TTC) imprimables
