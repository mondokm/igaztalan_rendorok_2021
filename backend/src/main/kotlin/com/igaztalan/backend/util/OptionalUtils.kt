package com.igaztalan.backend.util

import java.util.*

fun <T> Optional<T>.toNullable(): T? =  if(this.isPresent) this.get()!! else null
