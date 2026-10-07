# Each target corresponds to a stage; unfinished targets print the milestone that implements them.
.PHONY: help check smoke s1 s2 s3 s4 analyze

help:
	@echo "Targets: check | smoke (M5) | s1 (M6) | s2 s3 s4 (M7) | analyze (M8)"

check:
	@python3 scripts/00_check_environment.py

smoke:
	@echo "Not implemented yet: milestone M5"; exit 1

s1:
	@echo "Not implemented yet: milestone M6"; exit 1

s2 s3 s4:
	@echo "Not implemented yet: milestone M7"; exit 1

analyze:
	@echo "Not implemented yet: milestone M8"; exit 1
