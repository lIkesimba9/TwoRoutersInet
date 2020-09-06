import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.node.ethernet.EtherSwitch;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import ned.DatarateChannel;

network TwoRouter
{
    types:
        channel ethline extends DatarateChannel
        {
         //   delay = 100ms;
            datarate = 100Mbps;
        }
        channel pppline extends DatarateChannel
        {
            //delay = 100ms;
            datarate = 100Mbps;
        }
    submodules:

        router0: Router {
            @display("p=311,200");
            ipv4.routingTable.routingFile = "router0.mrt";
            gates:
                pppg[1];
        }
        router1: Router {
            @display("p=174,200");
            ipv4.routingTable.routingFile = "router1.mrt";
            gates:
                pppg[1];
        }

   //     host1: StandardHost {
   //         @display("p=92,200");
   //         ipv4.routingTable.routingFile = "host1.mrt";
   //    }


    connections allowunconnected:
        router0.pppg[0] <--> pppline <--> router1.pppg[0];
     //   router1.ethg++ <--> ethline <--> host1.ethg++;
}
