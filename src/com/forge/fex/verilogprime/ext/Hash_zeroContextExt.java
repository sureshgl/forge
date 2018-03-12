package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Hash_zeroContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Hash_zeroContextExt extends AbstractBaseExt {

	public Hash_zeroContextExt(Hash_zeroContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Hash_zeroContext getContext() {
		return (Hash_zeroContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).hash_zero());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Hash_zeroContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Hash_zeroContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}