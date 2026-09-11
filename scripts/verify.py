"""Repeatable local/CI gate. Requires Python >=3.8, MoonBit, Node >=22."""
import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def run(*args):
    print("+ " + " ".join(args), flush=True)
    subprocess.run(args, cwd=ROOT, check=True)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--target", choices=["all", "wasm-gc", "wasm", "js", "native"], default="all")
    parser.add_argument("--native-check-only", action="store_true", help="Explicit local fallback without a C compiler; does NOT prove native execution")
    args = parser.parse_args()
    run("moon", "version", "--all")
    run("moon", "fmt", "--check")
    targets = ["wasm-gc", "wasm", "js", "native"] if args.target == "all" else [args.target]
    for target in targets:
        run("moon", "check", "--target", target, "--deny-warn")
        if target == "native" and args.native_check_only:
            print("DEFERRED: native build/test/example require CI C compiler", flush=True)
            continue
        run("moon", "build", "--target", target, "--release")
        run("moon", "test", "--target", target)
        run("moon", "run", "examples/rehearsal", "--target", target, "--release")
        if target == "js":
            run("node", "scripts/cli-smoke.mjs")
    run("moon", "info")
    run("git", "diff", "--exit-code", "--", "*.mbti")
    print("Verification passed" + (" (native execution DEFERRED)" if args.native_check_only and "native" in targets else ""))

if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as error:
        sys.exit(error.returncode)
