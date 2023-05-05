use Cro::HTTP::Client;

my $url = "https://localhost/foo.txt";

my Cro::HTTP::Client $cro .= new:
    :http<2>,
    tls => { ssl-key-log-file => "/home/patrickb/repos/RakudoCIBot/ssl-key-log-file", },
    ca => { :insecure };

my $c = 0;
loop {
    my $res = await $cro.get: $url;
    my $body = await $res.body-text;
    #last if $c++ > 10;
    #
    sleep 2.rand;
    say "$c";
    $c++;
    CATCH {
        default {
            say "========================================";
            say "EXCEPTION:";
            $*ERR.say: .message;
            for .backtrace.reverse {
                next unless .subname;
                $*ERR.say: "  in block {.subname} at {.file} line {.line}";
            }
            exit 1;
        }
    }
}
