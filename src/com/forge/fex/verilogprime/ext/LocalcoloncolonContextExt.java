package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.LocalcoloncolonContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class LocalcoloncolonContextExt extends AbstractBaseExt {

	public LocalcoloncolonContextExt(LocalcoloncolonContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public LocalcoloncolonContext getContext() {
		return (LocalcoloncolonContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).localcoloncolon());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof LocalcoloncolonContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ LocalcoloncolonContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}