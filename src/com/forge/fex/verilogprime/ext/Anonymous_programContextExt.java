package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Anonymous_programContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Anonymous_programContextExt extends AbstractBaseExt {

	public Anonymous_programContextExt(Anonymous_programContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Anonymous_programContext getContext() {
		return (Anonymous_programContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).anonymous_program());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Anonymous_programContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Anonymous_programContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}