package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.StartcoloncolonstarContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class StartcoloncolonstarContextExt extends AbstractBaseExt {

	public StartcoloncolonstarContextExt(StartcoloncolonstarContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public StartcoloncolonstarContext getContext() {
		return (StartcoloncolonstarContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).startcoloncolonstar());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof StartcoloncolonstarContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ StartcoloncolonstarContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}