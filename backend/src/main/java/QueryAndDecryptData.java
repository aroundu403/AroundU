/*
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [START cloud_sql_mysql_cse_query]

import com.google.crypto.tink.Aead;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import javax.sql.DataSource;

public class QueryAndDecryptData {

  public static void main(String[] args) throws GeneralSecurityException, SQLException {
    // Saving credentials in environment variables is convenient, but not secure - consider a more
    // secure solution such as Cloud Secret Manager to help keep secrets safe.
    String dbUser = System.getenv("DB_USER"); // e.g. "root", "mysql"
    String dbPass = System.getenv("DB_PASS"); // e.g. "mysupersecretpassword"
    String dbName = System.getenv("DB_NAME"); // e.g. "votes_db"
    String instanceConnectionName =
            System.getenv("INSTANCE_CONNECTION_NAME"); // e.g. "project-name:region:instance-name"
    System.out.println(dbName);
    String kmsUri = System.getenv("CLOUD_KMS_URI"); // e.g. "gcp-kms://projects/...path/to/key
    // Tink uses the "gcp-kms://" prefix for paths to keys stored in Google Cloud KMS. For more
    // info on creating a KMS key and getting its path, see
    // https://cloud.google.com/kms/docs/quickstart

    String tableName = "users";

    // Initialize database connection pool and create table if it does not exist
    // See CloudSqlConnectionPool.java for setup details
    DataSource pool =
        CloudSqlConnectionPool.createConnectionPool(dbUser, dbPass, dbName, instanceConnectionName);
    // CloudSqlConnectionPool.createTable(pool, tableName);

    // Initialize envelope AEAD
    // See CloudKmsEnvelopeAead.java for setup details
    Aead envAead = CloudKmsEnvelopeAead.get(kmsUri);

    // Insert row into table to test
    // See EncryptAndInsert.java for setup details
    //EncryptAndInsertData.encryptAndInsertData(
    //    pool, envAead, tableName, "newUser", "hello@example.com", "I am a new user");

    queryAndDecryptData(pool, envAead, tableName);
  }

  public static void queryAndDecryptData(DataSource pool, Aead envAead, String tableName)
      throws GeneralSecurityException, SQLException {

    try (Connection conn = pool.getConnection()) {
      String stmt =
          String.format(
              "SELECT user_name, email, description FROM %s WHERE id=1",
              tableName);
      try (PreparedStatement voteStmt = conn.prepareStatement(stmt) ) {
        ResultSet voteResults = voteStmt.executeQuery();

        System.out.println("user_name\temail\tdesc");
        while (voteResults.next()) {
          String userName = voteResults.getString(1);
          String email = voteResults.getString(2);
          String description = voteResults.getString(3);

          // Use the envelope AEAD primitive to encrypt the email, using the team name as
          // associated data. This binds the encryption of the email to the team name, preventing
          // associating an encrypted email in one row with a team name in another row.
          //String email = new String(envAead.decrypt(description.getBytes(), userName.getBytes()));

          System.out.println(String.format("%s\t%s\t%s", userName, email, description));
        }
      }
    }
  }
}
// [END cloud_sql_mysql_cse_query]
