package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Interface_ansi_headerContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Interface_ansi_headerContextExt extends AbstractBaseExt {

	public Interface_ansi_headerContextExt(Interface_ansi_headerContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Interface_ansi_headerContext getContext() {
		return (Interface_ansi_headerContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).interface_ansi_header());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Interface_ansi_headerContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Interface_ansi_headerContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}