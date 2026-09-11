// Only host I/O lives in JavaScript; parsing/reporting/dispatch are MoonBit.

///|
extern "js" fn read_input(path : String) -> String =
  #| (path) => { try {
  #| const fs = require('node:fs'); const fd = path === '-' ? 0 : fs.openSync(path, 'r');
  #| const chunks = []; let count = 0;
  #| try { while (true) { const b = Buffer.allocUnsafe(65536); const n = fs.readSync(fd,b,0,b.length,null); if (!n) break; count += n; if (count > 4194304) throw new Error('input exceeds 4 MiB'); chunks.push(b.subarray(0,n)); } }
  #| finally { if (fd !== 0) fs.closeSync(fd); }
  #| return new TextDecoder('utf-8', {fatal:true, ignoreBOM:true}).decode(Buffer.concat(chunks));
  #| } catch(e) { console.error('moonfountain: ' + e.message); process.exitCode=2; return ''; } }

///|
extern "js" fn io_failed() -> Bool =
  #| () => process.exitCode === 2

///|
extern "js" fn write_output(
  stdout : String,
  stderr : String,
  status : Int,
) -> Unit =
  #| (out,err,code) => { process.stdout.write(out); process.stderr.write(err); process.exitCode=code; }

///|
fn main {
  let args = @env.args()
  if args.length() == 3 && (args[2] == "--help" || args[2] == "help") {
    write_output(@fountain.usage(), "", 0)
    return
  }
  if args.length() < 4 ||
    args.length() > 5 ||
    (args[2] == "cues" && args.length() != 5) ||
    (args[2] != "cues" && args.length() == 5) {
    write_output("", @fountain.usage(), 2)
    return
  }
  if !["json", "json-source", "html", "scenes", "cast", "lint", "cues"].contains(
      args[2],
    ) {
    write_output("", @fountain.usage(), 2)
    return
  }
  let source = read_input(args[3])
  if io_failed() {
    return
  }
  let result = @fountain.command(
    args[2],
    source,
    argument=if args.length() == 5 { args[4] } else { "" },
  )
  write_output(result.stdout, result.stderr, result.status)
}
