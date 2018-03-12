package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.XorequalContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class XorequalContextExt extends AbstractBaseExt {

	public XorequalContextExt(XorequalContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public XorequalContext getContext() {
		return (XorequalContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).xorequal());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof XorequalContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + XorequalContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}