package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Assignment_patternContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Assignment_patternContextExt extends AbstractBaseExt {

	public Assignment_patternContextExt(Assignment_patternContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Assignment_patternContext getContext() {
		return (Assignment_patternContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).assignment_pattern());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Assignment_patternContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Assignment_patternContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}