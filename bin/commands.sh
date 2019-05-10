echo "Sourcing commands"

fR() {
	dperm rcon nsheff/r bash
}
fpR() {
	dpipe nsheff/r R $@
}

fppy() {
	dpipe nsheff/python3 python3 $@
}