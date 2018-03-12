package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_mContext;

public class PortCap_mContextExt extends AbstractBaseExt {

	public PortCap_mContextExt(PortCap_mContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_mContext getContext() {
		return (PortCap_mContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_m());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_mContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_mContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}
